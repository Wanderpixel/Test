import { test } from "@playwright/test";
import { elementExists } from "../helper/page-helper";

test('customer account', async ({page}) => {
    await page.goto('/account');
    await elementExists(page, '.account-overview', 1);
});