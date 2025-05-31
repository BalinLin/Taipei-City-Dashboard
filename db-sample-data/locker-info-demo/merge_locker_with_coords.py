import pandas as pd
import re
import random

# 讀取置物櫃資訊
locker_df = pd.read_csv('捷運站置物櫃資訊.csv')
# 讀取出入口座標
coord_df = pd.read_csv('臺北捷運車站出入口座標.csv')

# 建立 mapping：出入口名稱(簡化) -> (經度, 緯度)
coord_map = dict()
for _, row in coord_df.iterrows():
    # 只取M3、出口1等關鍵字
    m = re.search(r'(M?\d+|出口\d+|\d+號出口)', row['出入口名稱'])
    if m:
        key = f"{row['出入口名稱'].split('站')[0]}站{m.group(1)}"
    else:
        key = row['出入口名稱']
    key = key.replace(' ', '')
    coord_map[key] = (row['經度'], row['緯度'])

def find_coords(station, location):
    m = re.search(r'(M?\d+|出口\d+|\d+號出口)', location)
    if m:
        key = f"{station}{m.group(1)}"
        key = key.replace(' ', '')
        if key in coord_map:
            return coord_map[key]
    # 若找不到詳細出口，僅用站名搜尋第一個出口
    # 例如「台北車站」-> 找「台北車站」開頭的第一個key
    for k in coord_map:
        if k.startswith(station):
            return coord_map[k]
    return (None, None)

# 先將置物櫃數量根據地點總和起來
if '置物櫃數量' in locker_df.columns:
    # 以地點名稱、置物櫃位置、行政區、縣市等欄位為 key 進行 groupby
    group_cols = [col for col in locker_df.columns if col in ['地點名稱', '置物櫃位置', '行政區', '縣市']]
    locker_df = locker_df.groupby(group_cols, as_index=False).agg({'置物櫃數量': 'sum'})

# 插入經緯度到置物櫃位置後面
cols = list(locker_df.columns)
loc_idx = cols.index('置物櫃位置')
# 新欄位順序
new_cols = cols[:loc_idx+1] + ['經度', '緯度'] + cols[loc_idx+1:]
locker_df['經度'], locker_df['緯度'] = zip(*locker_df.apply(lambda row: find_coords(row['地點名稱'], row['置物櫃位置']), axis=1))
locker_df = locker_df[new_cols]

# 刪除沒有經緯度的列
locker_df = locker_df.dropna(subset=['經度', '緯度'])

# 只保留經緯度後的置物櫃數量，並新增空位
cols = list(locker_df.columns)
loc_idx = cols.index('緯度')
# 新欄位順序：到緯度、置物櫃數量、置物櫃空位
new_cols = cols[:loc_idx+1] + ['置物櫃數量', '置物櫃空位']

# 隨機產生空位（小於數量）
def gen_vacant(n):
    if n > 1:
        return random.randint(0, n-1)
    return 0
locker_df['置物櫃空位'] = locker_df['置物櫃數量'].apply(lambda x: gen_vacant(int(x)))
locker_df = locker_df[new_cols]

def gen_vacant_by_district(row):
    n = int(row['置物櫃數量'])
    district = row['行政區'] if '行政區' in row else ''
    if n <= 0:
        return 0
    if district in ['信義區', '淡水區', '板橋區']:
        # 小於20%
        return random.randint(0, max(0, int(n * 0.19)))
    elif district in ['內湖區', '大安區', '萬華區']:
        # 40%~60%
        low = int(n * 0.4)
        high = max(low, int(n * 0.6))
        if high > n:
            high = n
        return random.randint(low, high)
    else:
        # 大於80%
        low = int(n * 0.8) + 1
        if low > n:
            low = n
        return random.randint(low, n)

locker_df['置物櫃空位'] = locker_df.apply(gen_vacant_by_district, axis=1)
locker_df = locker_df[new_cols]

locker_df.to_csv('捷運站置物櫃資訊_含經緯度.csv', index=False)

# 額外拉出台北市的資料
locker_df_taipei = locker_df[locker_df['縣市'].isin(['台北市', '臺北市'])]
locker_df_taipei.to_csv('捷運站置物櫃資訊_含經緯度_台北市.csv', index=False)

print('已完成：刪除無經緯度、只保留數量與空位，並隨機產生空位')
print('已額外輸出：捷運站置物櫃資訊_含經緯度_台北市.csv')
