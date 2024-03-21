import { test, expect } from "@playwright/test";
import { elementExists } from "../helper/page-helper";
import { PRODUCT_URL, CATEGORY_URL } from "../helper/product-helper";

test('product list styling', async ({page}) => {
    await page.goto(CATEGORY_URL);
    await elementExists(page, '#filter-panel-wrapper');
    await elementExists(page, '.cms-element-product-listing-wrapper');
    expect(await page.screenshot()).toMatchSnapshot();
});

test('product detail styling', async ({page}) => {
    await page.goto(PRODUCT_URL);
    await elementExists(page, '.product-detail');
    await elementExists(page, '.product-detail-buy');
    expect(await page.screenshot()).toMatchSnapshot();
});