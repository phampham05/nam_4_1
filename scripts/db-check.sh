#!/usr/bin/env bash
# Kiểm tra database đã nạp đúng dữ liệu chuẩn từ database/bookstore.sql
set -euo pipefail

CONTAINER="np-mysql"

if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER"; then
  echo "❌ Container $CONTAINER chưa chạy. Hãy chạy: npm run db:up"
  exit 1
fi

docker exec "$CONTAINER" sh -c 'MYSQL_PWD="$MYSQL_PASSWORD" mysql -u"$MYSQL_USER" "$MYSQL_DATABASE" -e "
SELECT \"Số bảng\" AS muc, COUNT(*) AS thuc_te, 14 AS mong_doi FROM information_schema.tables WHERE table_schema = DATABASE()
UNION ALL SELECT \"book\", COUNT(*), 19 FROM book
UNION ALL SELECT \"user\", COUNT(*), 18 FROM user
UNION ALL SELECT \"orders\", COUNT(*), 30 FROM orders
UNION ALL SELECT \"review\", COUNT(*), 4 FROM review
UNION ALL SELECT \"role\", COUNT(*), 2 FROM role;"'