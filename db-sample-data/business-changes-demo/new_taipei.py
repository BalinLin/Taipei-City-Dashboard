import pandas as pd

# 讀取 CSV 檔案
df = pd.read_csv('新北市商業登記清冊.csv', dtype=str)

# 移除 address_code 欄位中的「新北市」
df['address_code'] = df['address_code'].str.replace('新北市', '', regex=False)

# 篩選 set_app_date 在 1140401 ~ 1140430 之間的資料
mask = (df['set_app_date'] >= '1140301') & (df['set_app_date'] <= '1140331')
filtered_df = df[mask]

# 輸出結果
filtered_df.to_csv('app_at_11403.csv', index=False)
print(f"篩選後的資料筆數：{len(filtered_df)}")

# 篩選 set_app_date 在 1140401 ~ 1140430 之間的資料
mask = (df['close_app_date'] >= '1140301') & (df['close_app_date'] <= '1140331')
filtered_df = df[mask]

# 輸出結果
filtered_df.to_csv('close_at_11403.csv', index=False)
print(f"篩選後的資料筆數：{len(filtered_df)}")
