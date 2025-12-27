# راهنمای پاکسازی فایل‌های حساس از Git History

## ⚠️ هشدار امنیتی
فایل‌های حساس زیر قبلاً به Git اضافه شده‌اند و باید فوراً اقدام کنید:

1. `android/bermooda.jks` - Keystore file
2. `android/key.properties` - Contains keystore passwords
3. `android/app/google-services.json` - Contains Firebase API keys
4. `lib/firebase_options.dart` - Contains hardcoded Firebase API keys

## اقدامات فوری:

### 1. تغییر تمام Credentials
- **Keystore**: یک keystore جدید ایجاد کنید
- **Firebase API Keys**: در Firebase Console تمام API keys را regenerate کنید
- **Passwords**: تمام پسوردهای keystore را تغییر دهید

### 2. حذف فایل‌ها از Git History

#### روش 1: استفاده از git-filter-repo (توصیه می‌شود)

```bash
# نصب git-filter-repo (اگر نصب نیست)
pip install git-filter-repo

# حذف فایل‌های حساس از history
git filter-repo --path android/bermooda.jks --invert-paths --force
git filter-repo --path android/key.properties --invert-paths --force
git filter-repo --path android/app/google-services.json --invert-paths --force
git filter-repo --path lib/firebase_options.dart --invert-paths --force
```

#### روش 2: استفاده از git filter-branch (اگر git-filter-repo در دسترس نیست)

```bash
# حذف فایل‌ها از history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch android/bermooda.jks android/key.properties android/app/google-services.json lib/firebase_options.dart" \
  --prune-empty --tag-name-filter cat -- --all
```

#### روش 3: استفاده از BFG Repo-Cleaner

```bash
# دانلود BFG: https://rtyley.github.io/bfg-repo-cleaner/
java -jar bfg.jar --delete-files bermooda.jks
java -jar bfg.jar --delete-files key.properties
java -jar bfg.jar --delete-files google-services.json
java -jar bfg.jar --delete-files firebase_options.dart
git reflog expire --expire=now --all && git gc --prune=now --aggressive
```

### 3. Force Push به Remote Repository

⚠️ **هشدار**: این کار history را تغییر می‌دهد و نیاز به هماهنگی با تیم دارد.

```bash
# پاک کردن refs قدیمی
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force push (فقط بعد از هماهنگی با تیم)
git push origin --force --all
git push origin --force --tags
```

### 4. ساخت فایل‌های نمونه (Template)

برای تیم، فایل‌های نمونه بسازید:

```bash
# ساخت key.properties.example
cp android/key.properties android/key.properties.example
# سپس مقادیر حساس را جایگزین کنید با placeholder:
# storePassword=YOUR_STORE_PASSWORD
# keyPassword=YOUR_KEY_PASSWORD
# keyAlias=your_key_alias
# storeFile=path/to/your/keystore.jks
```

### 5. اطلاع‌رسانی به تیم

- تمام اعضای تیم باید repository را دوباره clone کنند
- هر کس باید فایل‌های حساس را از `.env` و فایل‌های محلی تنظیم کند
- Keystore جدید را به صورت امن به تیم منتقل کنید

### 6. بررسی نهایی

```bash
# بررسی که فایل‌ها از history حذف شده‌اند
git log --all --full-history -- android/bermooda.jks
git log --all --full-history -- android/key.properties
```

اگر چیزی نمایش داده نشد، یعنی حذف شده‌اند.

## نکات مهم:

1. **همیشه** قبل از force push با تیم هماهنگ کنید
2. **پشتیبان** از repository فعلی بگیرید
3. **تمام credentials** را تغییر دهید، نه فقط حذف از Git
4. از این پس از `.gitignore` برای جلوگیری از commit این فایل‌ها استفاده کنید

