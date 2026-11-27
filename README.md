# Gari Tracker – setup (sab free)

Files: `index.html` (poori app), `setup.sql` (database tables).

## 1. Database (Supabase, free)
1. supabase.com par free account banao, **New project** banao.
2. Left menu **SQL Editor** → New query → `setup.sql` ka poora text paste → **Run**.
3. **Authentication → Providers → Email** mein **Confirm email** band kar do (warna signup ke baad email confirm karni paray gi).
4. **Project Settings → API** se do cheezein copy karo:
   - Project URL
   - `anon` public key

## 2. Keys app mein daalo
`index.html` kholo, upar ye do lines dhoondo aur apni values paste karo:

```js
const SUPABASE_URL = "PASTE_YOUR_SUPABASE_URL";
const SUPABASE_ANON_KEY = "PASTE_YOUR_SUPABASE_ANON_KEY";
```

`anon` key public hoti hai, usse masla nahi. Data ko RLS rules protect karte hain: har banda sirf apna data dekhta hai. `service_role` key kabhi paste mat karna.

## 3. Free hosting (koi ek)
- **Netlify Drop**: app.netlify.com/drop par `index.html` wala folder drag-drop karo. Link mil jata hai.
- **Cloudflare Pages** ya **GitHub Pages**: repo mein `index.html` upload karo, Pages on karo.

Link phone ke browser mein kholo → "Add to Home Screen".

## 4. Istemal
1. Account banao (email + password), login karo.
2. **+ Gari** se bike, car, Mazda, pickup add karo.
3. **Petrol** tab: date, meter reading, litres, paisay. Tanki full ki ho to tick rakho.
4. **Maintenance** tab: kaam, kharcha, meter, aur "agli service kitne km par" (reminder ke liye).
5. **Hisaab** tab: average km/L, per 100 km, best/worst, per km kharcha, total petrol + maintenance, service reminder.

## Average kaise nikalta hai
Full tank se agli full tank tak: `km chalay ÷ beech mein dala hua total petrol`. Beech mein adhi tanki bhi dalwai ho to "Full" tick hata do, app khud jod leti hai. Pehli full entry sirf starting point hoti hai, isliye average ke liye kam az kam 2 full-tank entries chahiye.
