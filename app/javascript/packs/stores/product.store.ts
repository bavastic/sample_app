import axios from "axios";
import { action } from 'mobx';
import { logger } from '../common/logger';

import SimpleStore from './simple.store';

import Product from '../models/product.model';

/**
 * Store provider for everything about products.
 */
export default class ProductStore extends SimpleStore<Product> {

  FIXERIO_KEY = '289a3992c9e255b4c5ba30aa0364f425';

  constructor() {
    super();

    this.modelName = 'product';
    this.basePath = '/api/products';
  }

  @action
  public applyExchangeRate = async (item: Product | null) => {
    logger.of('ProductStore.applyExchangeRate').data('item', item);

    if (item !== null) {
      if (item.currency === item.displayCurrency) {
        item.displayPrice = item.price;
      } else {
        const { currency: base, displayCurrency: symbol } = item;

        const exchange = await this.getLatestExchange(base, symbol);

        if (exchange.data.success) {
          const rate = exchange.data.rates[symbol];
          item.displayPrice = Math.floor((item.price * rate) * 100) / 100;
        }
      }

      this.setSelectedItem(item);
    }
  };

  public uploadProductFile(file) {

    return(this.api.post(this.basePath+'/upload', file));
  }

  private getLatestExchange = async (base: string, symbol: string) => {
    try {
      const url = `https://data.fixer.io/api/latest?access_key=${this.FIXERIO_KEY}&base=${base}&symbols=${symbol}`;

      return await axios.get(url, { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } })
    } catch (error) {
      logger.of('ProductStore.getRate').error(error);
    }
  }
}

export let store = new ProductStore();
