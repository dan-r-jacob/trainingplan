# Training plan app

A training plan and run log, hosted on GitHub Pages, with your log synced through Supabase. It works offline and can be installed on your phone's home screen.

## What's in this folder

| File | What it does |
|---|---|
| `index.html` | The app itself |
| `config.js` | Your Supabase project details (you fill this in) |
| `supabase-setup.sql` | Creates the database table and its security rules |
| `manifest.webmanifest`, `sw.js`, `icons/` | Make it installable and let it work offline |

## 1. Create the database table

1. Open your project in Supabase and go to **SQL Editor**.
2. Start a new query, paste in everything from `supabase-setup.sql`, and click **Run**.

This creates a `training_log` table with row-level security switched on, so each signed-in person can only ever read or change their own log.

## 2. Set up sign-in

The app signs in with an email address and password. That works on Supabase's built-in email service with no custom SMTP: the only email involved is a one-off confirmation when you create your account, and you can switch even that off.

Supabase's built-in email service only sends to the email addresses of your Supabase organisation's members, and only a couple of emails an hour. So create your app account with the same email address you use for Supabase.

1. Go to **Authentication → URL Configuration**.
   - Set **Site URL** to your GitHub Pages address, for example `https://yourname.github.io/mcr27/` (you get this in step 4; come back and fill it in).
   - Add the same address under **Redirect URLs**.
2. Go to **Authentication → Sign In / Providers** and open **Email**. Check that the email provider is enabled.
3. Choose one:
   - **Simplest:** turn off **Confirm email** and save. No emails are sent at all; you just create an account and you're signed in.
   - **Or** leave it on. When you create your account you'll get one confirmation email; tap its link, then sign in.

The "Email me a sign-in link instead" option in the app also works, but it uses up the hourly email allowance and, on iPhone, the link opens in Safari rather than the home-screen app. Password sign-in avoids both.

## 3. Add your project details to `config.js`

1. In your Supabase project, click **Connect** at the top of the page. It shows your **Project URL** and **publishable key**. (You can also find every key under **Project Settings → API Keys**.)
2. Open `config.js` in a text editor and paste:
   - the Project URL (looks like `https://abcdefgh.supabase.co`) into `supabaseUrl`
   - the publishable key (starts `sb_publishable_`) into `supabaseKey`
3. Save the file.

Use the publishable key rather than the older `anon` key, which Supabase is retiring. Never use a secret (`sb_secret_`) or `service_role` key: those must never go in a web page. The publishable key is designed to be public; the security rules from step 1 are what protect your data.

If `config.js` is left unfilled, the app still works but saves on that device only.

## 4. Publish on GitHub Pages

1. Create a new repository on GitHub, for example `mcr27`.
2. Upload every file in this folder, keeping the `icons` folder as a folder. (On the repository page: **Add file → Upload files**, then drag the files and the icons folder in.)
3. Go to **Settings → Pages**. Under **Build and deployment**, choose **Deploy from a branch**, pick `main` and `/ (root)`, and save.
4. After a minute or two, your address appears at the top of that page. Put it into Supabase (step 2) if you haven't already.

Note: on a free GitHub account the repository needs to be public for Pages to work. That means anyone could see the plan itself, but not your log, which only exists in your Supabase account behind sign-in.

## 5. Install it on your phone

- **iPhone:** open the address in Safari, tap **Share → Add to Home Screen**. Open the app from the new icon, tap **Sign in to sync** and sign in with your email and password.
- **Android:** open the address in Chrome, then use the menu's **Install app** or **Add to Home screen**, open it and sign in.

## 6. Lock it down (recommended)

Once your account exists, go to **Authentication → Sign In / Providers** and turn off **Allow new users to sign up**. Your log is private either way, but this stops anyone else creating an account on your project, which matters most if you turned off email confirmation.


## Adding a plan for a new race

Plans are JSON files. The app has no plan built in: when someone signs in for the first time, it shows a welcome screen asking them to add their first plan. All plan-specific text (race details, weekly focus, session notes and plan notes) comes from the plan file.

1. Open **Your plans** (or the welcome screen, if you have no plans yet) and choose a prompt:
   - **Create a new plan**: the AI asks about your fitness and goals, then builds a plan.
   - **Convert a plan you already have**: paste your existing plan after the prompt, and the AI reformats it without changing the training.
2. Paste the prompt into Claude, ChatGPT or another AI tool and answer its questions.
3. When it gives you the plan as a JSON code block, copy it, paste it into **Or paste the plan here**, and tap **Add pasted plan**. (Or save it as a `.json` file and use **Upload plan file**.)
4. The app checks the plan, lists anything it had to adjust, and switches to it. The headline, graph, paces and predictions all follow the new race.

Each plan keeps its own log. Switch plans with the **Plan** menu at the top of the page or under **Your plans**. Adding a plan with the same `id` as an existing one replaces that plan but keeps its log.

Plans are saved in your Supabase account with your log, so there's nothing to upload to GitHub.

## Updating later

Edit or replace files in the GitHub repository and the app picks up the changes the next time it's opened with a connection. If you ever change the list of files in `sw.js`, also change `CACHE = "runlog-v3"` to `"runlog-v4"` so phones refresh their offline copy.

## How syncing works

Every change saves on the device straight away. When you're signed in and online, the app fetches your latest log, merges it with any changes from this device (the most recent edit to each run wins), and saves the result back. It does this after each change, when the app comes back into view, and when your connection returns. You can also download a full backup at any time under **Backup and import**.
