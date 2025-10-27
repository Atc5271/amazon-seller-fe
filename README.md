# Amazon Seller Dashboard (Option A - Separate backend & frontend)

## Structure

```
amazon-seller-dashboard/
├── backend/      # Spring Boot app (MySQL)
├── frontend/     # Vue 3 + Vite
├── sql/
│   └── sellers.sql
└── README.md
```

## Quick start (MySQL + Spring Boot + Vue)

1. Create MySQL database:

```sql
CREATE DATABASE sellerdb;
```

2. Run `sql/sellers.sql` against your MySQL to create tables and seed sample data.

3. Backend:

```bash
cd backend
# set DB credentials in src/main/resources/application.properties
mvn clean package
java -jar target/seller-dashboard-0.1.0.jar
```

Backend runs on port 8080 by default.

4. Frontend:

```bash
cd frontend
npm install
npm run dev
```

Frontend runs on port 5173 by default. Configure a proxy or enable CORS if needed.

## Notes
- Caching: per-seller in-memory cache TTL = 30s in SellerService.
- Alerts: implemented as described (sales drop >30% vs last week, return rate >10%).

Enjoy!