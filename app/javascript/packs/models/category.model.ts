import Record from './record.model';

/**
 * Model for a Category, just defines lightweight the shape of data.
 */

interface Category extends Record {
  parentId: number;
  parentName: string;
  name: string;
  productsCount: number;
  gIdentifier: string;
}

export default Category;
