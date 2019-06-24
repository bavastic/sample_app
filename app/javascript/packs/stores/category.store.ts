import SimpleStore from './simple.store';
import axios from 'axios';

import Category from '../models/category.model';
import { logger } from '../common/logger';

/**
 * Store provider for everything about categories.
 */
export default class CategoryStore extends SimpleStore<Category> {

  constructor() {
    super();

    this.modelName = 'category';
    this.basePath = '/api/categories';
  }

  public uploadCategoryFile(file) {
    return(this.api.post(this.basePath+'/upload', file));
  }

}

export let store = new CategoryStore();
