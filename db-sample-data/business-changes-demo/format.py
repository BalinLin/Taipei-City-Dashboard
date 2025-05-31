import pandas as pd
import re

def split_address(df):
    # 使用正則表達式分割「臺北市xx區」
    df['縣市'] = df['商業地址'].str.extract(r'^(臺北市)')
    df['行政區'] = df['商業地址'].str.extract(r'^臺北市(.{2,3}區)')
    return df

# 讀取 CSV，指定「統一編號」為字串型別，避免前導 0 消失
df_set = pd.read_csv('./商業設立11404.csv', dtype={'統一編號': str})
df_close = pd.read_csv('./商業歇業11404.csv', dtype={'統一編號': str})

# 分割地址
df_set = split_address(df_set)
df_close = split_address(df_close)
df_all = pd.concat([df_set, df_close], ignore_index=True)

# 儲存結果
df_set.to_csv('./商業設立11404_分割.csv', index=False)
df_close.to_csv('./商業歇業11404_分割.csv', index=False)
df_all.to_csv('./商業變更11404_分割.csv', index=False)
