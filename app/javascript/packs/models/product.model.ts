import Record from './record.model';

/**
 * Model for a Product, just defines lightweight the shape of data.
 */

interface Product extends Record {
  categoryId: number;
  categoryName: string;
  name: string;
  price: number;
  currency: string;
  displayPrice?: number;
  displayCurrency: string;
  identifier: string;
}

export default Product;
