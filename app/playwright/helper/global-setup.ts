import { chromium, FullConfig } from "@playwright/test";

// @ts-ignore
import dotenv from "dotenv";

dotenv.config();

async function globalSetup(config: FullConfig) {
    const browser = await chromium.launch();
    const page = await browser.newPage();
    await page.goto(process.env.DOMAIN + '/account');
    await page.fill('#loginMail', process.env.TEST_CUSTOMER);
    await page.fill('#loginPassword', process.env.TEST_PASSWORD);
    await page.click('.login-submit button[type="submit"]');

    await page.context().storageState({ path: 'storageState.json' });
    await browser.close();
}

export default globalSetup;