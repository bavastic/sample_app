import SimpleStore from './simple.store';
import axios from 'axios';

import Category from '../models/category.model';

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
    console.log(this.basePath+'/upload')
    this.api.post(this.basePath+'/upload', file).then(res => {
      console.log(res.statusText)
    });
  }

}

export let store = new CategoryStore();
