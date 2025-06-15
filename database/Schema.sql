CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  full_name TEXT,
  avatar_url TEXT,
  phone TEXT,
  address TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (id)
);

CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  category_id INTEGER REFERENCES categories(id),
  image_urls TEXT[],
  stock_quantity INTEGER DEFAULT 0,
  rating DECIMAL(2,1) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE cart_items (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, product_id)
);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  total_amount DECIMAL(10,2) NOT NULL,
  status TEXT DEFAULT 'pending',
  shipping_address TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
  product_id INTEGER REFERENCES products(id),
  quantity INTEGER NOT NULL,
  price DECIMAL(10,2) NOT NULL
);

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view own profile" ON profiles 
  FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles 
  FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON profiles 
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Cart policies
CREATE POLICY "Users can view own cart" ON cart_items 
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own cart items" ON cart_items 
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own cart items" ON cart_items 
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own cart items" ON cart_items 
  FOR DELETE USING (auth.uid() = user_id);

-- Products policies (public read access)
CREATE POLICY "Anyone can view products" ON products 
  FOR SELECT USING (true);

-- Categories policies (public read access)
CREATE POLICY "Anyone can view categories" ON categories 
  FOR SELECT USING (true);

-- Orders policies
CREATE POLICY "Users can view own orders" ON orders 
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own orders" ON orders 
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Order items policies
CREATE POLICY "Users can view own order items" ON order_items 
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM orders 
      WHERE orders.id = order_items.order_id 
      AND orders.user_id = auth.uid()
    )
  );


  INSERT INTO categories (name, description) VALUES 
('Electronics', 'Electronic devices and gadgets'),
('Clothing', 'Fashion and apparel'),
('Books', 'Books and literature'),
('Home & Garden', 'Home improvement and gardening'),
('Sports', 'Sports and fitness equipment'),
('Beauty', 'Beauty and personal care products');


INSERT INTO products (name, description, price, category_id, stock_quantity, rating) VALUES 
-- Electronics
('iPhone 15', 'Latest Apple smartphone with advanced features and A17 chip', 999.99, 1, 50, 4.5),
('Samsung Galaxy S24', 'Android flagship phone with great camera and display', 899.99, 1, 30, 4.3),
('MacBook Air M2', 'Lightweight laptop perfect for professionals and students', 1199.99, 1, 25, 4.7),
('iPad Pro', 'Powerful tablet for creative professionals', 799.99, 1, 40, 4.6),
('AirPods Pro', 'Wireless earbuds with noise cancellation', 249.99, 1, 100, 4.4),

-- Clothing
('Nike Air Max', 'Comfortable running shoes for athletes and casual wear', 129.99, 2, 100, 4.2),
('Levi''s Jeans', 'Classic denim jeans for everyday wear', 79.99, 2, 75, 4.0),
('Adidas Hoodie', 'Comfortable cotton hoodie for casual occasions', 59.99, 2, 60, 4.1),
('Nike T-Shirt', 'Premium cotton t-shirt with modern fit', 29.99, 2, 120, 4.3),

-- Books
('The Great Gatsby', 'Classic American novel by F. Scott Fitzgerald', 12.99, 3, 200, 4.7),
('Harry Potter Set', 'Complete collection of Harry Potter books', 89.99, 3, 50, 4.9),
('Programming Book', 'Learn Flutter development from scratch', 45.99, 3, 80, 4.5),
('Cooking Guide', 'Master chef techniques and recipes', 24.99, 3, 90, 4.2),

-- Home & Garden
('Garden Tools Set', 'Complete set of essential garden tools', 45.99, 4, 40, 4.1),
('Coffee Maker', 'Automatic drip coffee maker with timer', 89.99, 4, 35, 4.4),
('Vacuum Cleaner', 'Powerful cordless vacuum for home cleaning', 199.99, 4, 25, 4.3),

-- Sports
('Yoga Mat', 'Non-slip exercise mat for yoga and fitness', 34.99, 5, 80, 4.2),
('Dumbbells Set', 'Adjustable weight dumbbells for home gym', 149.99, 5, 30, 4.5),

-- Beauty
('Skincare Set', 'Complete skincare routine for healthy skin', 79.99, 6, 60, 4.6),
('Hair Dryer', 'Professional ionic hair dryer', 89.99, 6, 45, 4.3);


-- Complete Database Backup Script
-- Run this in Supabase SQL Editor to recreate everything

-- 1. Create Tables
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  full_name TEXT,
  avatar_url TEXT,
  phone TEXT,
  address TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  category_id INTEGER REFERENCES categories(id),
  image_urls TEXT[],
  stock_quantity INTEGER DEFAULT 0,
  rating DECIMAL(2,1) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS cart_items (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, product_id)
);

CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  total_amount DECIMAL(10,2) NOT NULL,
  status TEXT DEFAULT 'pending',
  shipping_address TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
  product_id INTEGER REFERENCES products(id),
  quantity INTEGER NOT NULL,
  price DECIMAL(10,2) NOT NULL
);

-- 2. Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- 3. Create Policies (add all the policies from above)

-- 4. Insert Sample Data (add all the sample data from above)