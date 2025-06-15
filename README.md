# Flutter Ecommerce Database

## Tables Overview
- **profiles**: User profile information
- **categories**: Product categories
- **products**: Product catalog
- **cart_items**: Shopping cart items
- **orders**: Customer orders
- **order_items**: Individual items in orders

## Key Relationships
- Users (auth.users) → profiles (1:1)
- Users → cart_items (1:many)
- Users → orders (1:many)
- Categories → products (1:many)
- Products → cart_items (1:many)
- Orders → order_items (1:many)

## Setup Instructions
1. Run schema.sql to create tables
2. Run policies.sql to set up security
3. Run sample_data.sql to add test data

## Backup Instructions
- Export data regularly using Supabase dashboard
- Keep schema files updated when making changes


flutter_ecommerce/
├── database/
│   ├── schema.sql              # Table definitions
│   ├── policies.sql            # RLS policies
│   ├── sample_data.sql         # Sample data
│   ├── complete_backup.sql     # Full backup
│   └── README.md              # Database documentation
├── lib/
└── ...