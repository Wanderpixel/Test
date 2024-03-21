import { test, expect } from "@playwright/test";
import { PRODUCT_URL, addToCart } from "../helper/product-helper";
import { elementExists } from "../helper/page-helper";

const ORDER_QUANTITY = 3;

test('test order', async ({page}) => {
    await page.goto(PRODUCT_URL);
    await addToCart(page, ORDER_QUANTITY);
    await page.goto('/checkout/confirm');
    await elementExists(page, '.confirm-product');
    expect(await page.inputValue('.quantity-select')).toEqual(ORDER_QUANTITY.toString());

    // TODO: select payment method by id

    await page.click('#tos', { force: true });
    expect(await page.isChecked('#tos')).toBeTruthy();

    await page.click('#confirmFormSubmit');
});