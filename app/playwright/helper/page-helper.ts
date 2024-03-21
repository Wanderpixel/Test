import { expect, Page } from "@playwright/test";

export async function elementExists(page: Page, selector: string, count: number = 1) {
    await expect(page.locator(selector)).toHaveCount(count);
}

export async function elementMissing(page: Page, selector: string) {
    await expect(page.locator(selector)).toHaveCount(0);
}