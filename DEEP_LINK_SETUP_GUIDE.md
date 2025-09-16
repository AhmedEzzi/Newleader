# 🚀 Deep Link Setup Guide - Ready to Deploy!

## 📁 Files Created
- ✅ `assetlinks.json` - Android verification file
- ✅ All Flutter code is ready and configured

## 🛠 Step-by-Step Setup Instructions

### 1. Upload the assetlinks.json file

**You need to upload the `assetlinks.json` file to your website at this exact location:**

```
https://admin.leadercompany-eg.com/.well-known/assetlinks.json
```

**How to do it:**
1. Access your website's file manager or FTP
2. Create a folder called `.well-known` in the root directory
3. Upload the `assetlinks.json` file inside that folder
4. Make sure the file is accessible at the URL above

### 2. Verify the file is working

**Test by visiting this URL in your browser:**
```
https://admin.leadercompany-eg.com/.well-known/assetlinks.json
```

**You should see the JSON content displayed. If you get a 404 error, the file isn't in the right place.**

### 3. Test Android Deep Linking

**Use Google's official tool to verify:**
1. Go to: https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://admin.leadercompany-eg.com&relation=delegate_permission/common.handle_all_urls
2. You should see your app listed if everything is working

### 4. Test the Deep Links

**Create test links:**
- `https://admin.leadercompany-eg.com/product/test-product`
- `https://leadercompany-eg.com/product/test-product`

**Test on Android:**
1. Share a product from your app
2. Send the link to another Android device
3. Click the link - it should open in your app (if installed) or browser (if not installed)

## 🔧 Additional Configuration (Optional)

### For iOS Universal Links (if needed)

If you want iOS to also work with your domain, add this to your website's root:

**Create: `apple-app-site-association` (no file extension)**

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAMID.com.leadercompany",
        "paths": ["/product/*"]
      }
    ]
  }
}
```

**Replace `TEAMID` with your Apple Developer Team ID**

## ✅ Verification Checklist

- [ ] `assetlinks.json` file uploaded to `https://admin.leadercompany-eg.com/.well-known/assetlinks.json`
- [ ] File is accessible via browser (no 404 error)
- [ ] Google's verification tool shows your app
- [ ] Test links work on Android devices
- [ ] App opens when clicking shared links (if installed)
- [ ] Browser opens when clicking shared links (if app not installed)

## 🚨 Common Issues & Solutions

### Issue: Links always open in browser
**Solution:** Check that `assetlinks.json` is in the correct location and accessible

### Issue: 404 error when accessing assetlinks.json
**Solution:** Make sure the file is in `.well-known` folder (note the dot at the beginning)

### Issue: App doesn't open when clicking links
**Solution:** 
1. Verify the package name in `assetlinks.json` matches your app
2. Check that the SHA256 fingerprints are correct
3. Make sure the file is served over HTTPS

### Issue: "Open in App" option doesn't appear
**Solution:** This usually means the `assetlinks.json` file isn't properly configured or accessible

## 🎯 Expected Behavior

**When someone clicks your shared product link:**

1. **If your app is installed:**
   - Link opens directly in your app
   - Navigates to the product detail screen
   - No browser involved

2. **If your app is NOT installed:**
   - Link opens in browser
   - Shows product on your website
   - User can download the app
   - Future links will open in app after installation

## 📱 Testing on Different Devices

### Android Testing:
- Test on devices with app installed
- Test on devices without app installed
- Test on different Android versions

### iOS Testing:
- Test on devices with app installed
- Test on devices without app installed
- Test Universal Links if configured

## 🎉 You're Ready!

Once you upload the `assetlinks.json` file, your deep linking will be fully functional! Users will be able to share product links that open directly in your app.

**Need help?** Check the troubleshooting section above or test with Google's verification tool.
