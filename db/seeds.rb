Category.create([{ name: 'Electronics' }, { name: 'Clothing' }, { name: 'Books' }, { name: 'Furniture' }])
Product.create!(
  name: "Sample Product",
  category_id: 1,
  price: 100,
  stock: 50,
  description: "A sample product for testing",
  seller_id: 1
)
  