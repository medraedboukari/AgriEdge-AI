# ---
# jupyter:
#   jupytext:
#     formats: py:percent
#     text_representation:
#       extension: .py
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.19.4
#   kernelspec:
#     display_name: Python 3 (ipykernel)
#     language: python
#     name: python3
# ---

# %%
import os
print(os.getcwd())

# %%
import os
print(os.listdir('data'))

# %%
for dataset in ['plantvillage', 'cassava', 'tomato']:
    print(f"\n=== {dataset} ===")
    items = os.listdir(f'data/{dataset}')
    print(f"Nombre d'éléments : {len(items)}")
    print("Premiers éléments :")
    for item in items[:5]:
        print(f"  {item}")

# %%
for dataset, subdir in [
    ('plantvillage', 'PlantVillage Dataset'),
    ('cassava', 'cassava-leaf-disease-classification'),
    ('tomato', 'Tomato leaf disease detection')
]:
    path = f'data/{dataset}/{subdir}'
    print(f"\n=== {dataset} ===")
    items = os.listdir(path)
    print(f"Nombre d'éléments : {len(items)}")
    for item in items[:5]:
        print(f"  {item}")

# %%
# PlantVillage
pv_path = 'data/plantvillage/PlantVillage Dataset/PlantVillage'
print("=== PlantVillage ===")
classes = os.listdir(pv_path)
print(f"Nombre de classes : {len(classes)}")
for c in classes[:5]:
    print(f"  {c}")

# Tomato
print("\n=== Tomato ===")
tomato_path = 'data/tomato/Tomato leaf disease detection/tomato'
items = os.listdir(tomato_path)
print(f"Contenu : {items}")

# Cassava
print("\n=== Cassava ===")
print("Contenu train_images:")
cassava_path = 'data/cassava/cassava-leaf-disease-classification/test_images'
items = os.listdir(cassava_path)
print(f"Nombre images test : {len(items)}")
print(f"Exemple : {items[:3]}")

# %%
# PlantVillage
pv_path = 'data/plantvillage/PlantVillage Dataset/PlantVillage'
pv_total = 0
pv_classes = os.listdir(pv_path)
for c in pv_classes:
    imgs = os.listdir(f'{pv_path}/{c}')
    pv_total += len(imgs)
print(f"PlantVillage : {pv_total} images, {len(pv_classes)} classes")

# Tomato
tomato_train = 'data/tomato/Tomato leaf disease detection/tomato/train'
tomato_classes = os.listdir(tomato_train)
tomato_total = 0
for c in tomato_classes:
    imgs = os.listdir(f'{tomato_train}/{c}')
    tomato_total += len(imgs)
print(f"Tomato : {tomato_total} images, {len(tomato_classes)} classes")

# Cassava
import pandas as pd
cassava_csv = 'data/cassava/cassava-leaf-disease-classification/train.csv'
df = pd.read_csv(cassava_csv)
print(f"Cassava : {len(df)} images, {df['label'].nunique()} classes")

# %%
