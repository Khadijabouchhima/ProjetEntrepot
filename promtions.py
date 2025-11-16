import pandas as pd
import numpy as np

# Load your orders table
orders = pd.read_csv("orders.csv")

# Randomly assign ~15% of orders as promotion
np.random.seed(42)  # for reproducibility
orders['Promotion_Flag'] = np.random.choice([0,1], size=len(orders), p=[0.85, 0.15])

# Check result
orders['Promotion_Flag'].value_counts()