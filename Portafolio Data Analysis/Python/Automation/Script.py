import pandas as pd
import os

# Ruta al archivo de entrada
input_file = "coffeeOrdersData.xlsx"
output_file = "orders_completed.xlsx"

# Verifica si el archivo existe
if not os.path.exists(input_file):
    raise FileNotFoundError(f"No se encontró el archivo '{input_file}'.")

# Cargar hojas
orders = pd.read_excel(input_file, sheet_name="orders")
customers = pd.read_excel(input_file, sheet_name="customers")
products = pd.read_excel(input_file, sheet_name="products")

# Combinar con customers
orders = orders.drop(columns=["Customer Name", "Email", "Country"], errors="ignore").merge(
    customers[["Customer ID", "Customer Name", "Email", "Country"]],
    on="Customer ID", how="left"
)

# Combinar con products
orders = orders.drop(columns=["Coffee Type", "Roast Type", "Size", "Unit Price"], errors="ignore").merge(
    products[["Product ID", "Coffee Type", "Roast Type", "Size", "Unit Price"]],
    on="Product ID", how="left"
)

# Calcular columna Sales si no existe
if "Sales" not in orders.columns:
    orders["Sales"] = orders["Quantity"] * orders["Unit Price"]

# Reordenar columnas
final_columns = [
    'Order ID', 'Order Date', 'Customer ID', 'Product ID', 'Quantity',
    'Customer Name', 'Email', 'Country', 'Coffee Type', 'Roast Type',
    'Size', 'Unit Price', 'Sales'
]

# Guardar archivo final
orders.to_excel(output_file, columns=final_columns, index=False)
print(f"Archivo generado correctamente: {output_file}")
