import pandas as pd
df = pd.read_csv("sales.csv", sep='\t')
print(df)

df['Total'] = df['Quantity'] * df['Price']
print(df)

Ana_orders = df[df['Customer'] == 'Ana']
print(Ana_orders)

big_orders = df[df['Total'] > 500]
print(big_orders)

sales_per_customer = df.groupby('Customer')['Total'].sum()
print(sales_per_customer)

quantity_per_product = df.groupby('Product')['Quantity'].sum
print(quantity_per_product)

products = df['Product'].unique()
print(products)

sorted_df = df.sort_values(by = 'Total', ascending = False)
print(sorted_df)

total_sales = df['Total'].sum()
print(total_sales)

average_order = df['Total'].mean()
print(average_order)

max_order = df['Total'].max()
print(max_order)
min_order = df['Total'].min()
print(min_order)