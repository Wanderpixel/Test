import { Page } from "@playwright/test";
import { elementExists } from "./page-helper";

export const CATEGORY_URL = '/Bekleidung/';
export const PRODUCT_URL = '/Durable-Wool-Grainspot/e4f676fd300e47c1b7dcc6694d49638d';

export async function addToCart(page: Page, quantity: number = 1) {
    await page.selectOption('.product-detail-quantity-select', quantity.toString());
    await page.click('.buy-widget-container .btn-buy');
    await elementExists(page, '.cart-offcanvas.is-open');
}