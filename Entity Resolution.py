import pandas as pd

df = pd.read_parquet("veridion_entity_resolution_challenge.snappy.parquet", engine="pyarrow")

print(df.columns.tolist())

key_cols = [
    'company_name',
    'company_commercial_names',
    'main_country'
]

for col in key_cols:
    df[col] = df[col].fillna('').str.lower().str.strip()

df['key_combined'] = df[key_cols].agg('|'.join, axis=1)

df['group_id'] = df.groupby('key_combined').ngroup()

duplicates = df[df.duplicated('group_id', keep=False)]

print(duplicates[['company_name', 'company_commercial_names', 'main_country', 'group_id']]
      .sort_values('group_id')
      .head(20))

df.to_parquet("veridion_deduplicated.parquet", engine="pyarrow", index=False)


