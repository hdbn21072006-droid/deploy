# Hướng dẫn Deploy trên Render

## 1. Deploy Backend và Database trên Render

### Bước 1: Chuẩn bị
- Đăng ký tài khoản tại https://render.com/
- Kết nối GitHub với Render

### Bước 2: Deploy với render.yaml (Tự động)

1. Vào Render Dashboard → **New** → **Blueprint**
2. Chọn repository: `hdbn21072006-droid/deploy`
3. Chọn nhánh: `dang`
4. Render sẽ tự động đọc file `render.yaml` và tạo:
   - Web Service (Backend)
   - PostgreSQL Database

### Bước 3: Cấu hình Environment Variables

Sau khi deploy, vào Web Service → **Environment** tab, thêm:

```
GMAIL_EMAIL=hdbn21072006@gmail.com
GMAIL_APP_PASSWORD=llwp shcv btui wmyi
APP_URL=https://your-netlify-frontend-url.netlify.app
ALLOWED_ORIGINS=https://your-netlify-frontend-url.netlify.app,http://localhost:8000
```

### Bước 4: Chạy Migration Database

1. Vào Web Service → **Shell** tab
2. Chạy lệnh:
```bash
npx ts-node -p tsconfig.backend.json src/backend/database/migrate.ts
```

Hoặc chạy migration thủ công qua PostgreSQL Console trong Database service.

---

## 2. Deploy Frontend trên Netlify

### Bước 1: Chuẩn bị
- Đăng ký tài khoản tại https://netlify.com/
- Kết nối GitHub với Netlify

### Bước 2: Build Frontend
1. Vào Netlify Dashboard → **Add new site** → **Import from Git**
2. Chọn repository: `hdbn21072006-droid/deploy`
3. Chọn nhánh: `dang`
4. Cấu hình Build settings:
   - **Build command**: `npm run build`
   - **Publish directory**: `dist`
5. Thêm Environment Variables:
   ```
   API_URL=https://your-render-backend-url.onrender.com/api
   ```
6. Deploy

---

## 3. Cập nhật API URL trong Frontend

Cần cập nhật file `src/frontend/services/config.ts`:

```typescript
export const API_URL_AUTH = process.env.API_URL || 'http://localhost:5000/api/auth';
```

Hoặc tạo file `.env.production`:
```
API_URL=https://your-render-backend-url.onrender.com/api
```

---

## 4. Kiểm tra Deployment

### Backend
- Truy cập: `https://your-backend.onrender.com/api/database/health`
- Kiểm tra logs trong Render Dashboard

### Database
- Vào Database service → **Connections** tab
- Copy internal connection string

### Frontend
- Truy cập: `https://your-site.netlify.app`
- Test login/register

---

## 5. Lưu ý quan trọng

- Render có gói miễn phí nhưng service sẽ sleep sau 15 phút không hoạt động
- Lần request đầu tiên sau sleep sẽ mất ~30s để khởi động
- PostgreSQL trên Render có giới hạn 90 ngày dữ liệu trên gói miễn phí
- Cần cấu hình CORS trong backend cho phép frontend URL
- Render tự động đọc `render.yaml` để cấu hình deployment

---

## 6. Troubleshooting

### Build thất bại
- Kiểm tra **Logs** tab trong Web Service
- Đảm bảo Dockerfile đúng cấu trúc
- Kiểm tra package.json có đầy đủ dependencies

### Database không kết nối
- Kiểm tra Environment Variables có đúng thông tin database
- Đảm bảo database service đang chạy
- Test connection qua Render Console

### Frontend không gọi được API
- Kiểm tra CORS configuration
- Đảm bảo ALLOWED_ORIGINS có chứa frontend URL
- Kiểm tra API_URL trong Netlify Environment Variables
