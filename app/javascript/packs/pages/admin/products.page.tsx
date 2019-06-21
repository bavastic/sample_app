import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { List } from 'semantic-ui-react';

import UiStore, { Action } from '../../stores/ui.store';
import ProductStore from '../../stores/product.store';
import Product from '../../models/product.model';
import CategoryStore from '../../stores/category.store';

import Loading from '../../common/components/loading';
import RecordsListView from '../../common/components/records/list.view';
import { ProductForm } from './product.forms';
import { ProductUploadForm } from './product.upload';

interface Properties {
}

interface InjectedProps extends Properties {
  uiStore: UiStore;
  productStore: ProductStore;
  categoryStore: CategoryStore;
}

@inject('uiStore', 'productStore', 'categoryStore')
@observer
class ProductsAdminPage extends React.Component<Properties> {

  get injected() {
    return this.props as InjectedProps;
  }

  get uiStore() {
    return this.injected.uiStore;
  }

  get productStore() {
    return this.injected.productStore;
  }

  get categoryStore() {
    return this.injected.categoryStore;
  }

  componentDidMount() {
    this.productStore.getItems();

    // TODO: implement lazy evaluation, needed for form only
    this.categoryStore.getOptions();
  }

  public render() {
    if (this.productStore.isLoading) {
      return <Loading/>;
    }

    if (this.uiStore.selectedAction === Action.Index) {
      return (
        <RecordsListView
          records={this.productStore.items}
          selectedRecord={this.productStore.selectedItem}
          onSelectRecord={this.productStore.setSelectedItem}
          onDestroyRecord={this.productStore.destroyItem}
          onSystemNotification={this.uiStore.addNotifications}
          modalOpen={this.uiStore.modalOpen}
          modalContent={this.uiStore.modalContent}
          openModal={this.openModal}
          closeModal={this.closeModal}
          resetModal={this.resetModal}
          toggleModal={this.toggleModal}
          renderShowTemplate={this.templateShowAction}
          renderUpdateTemplate={this.templateUpdateAction}
          renderCreateTemplate={this.templateCreateAction}
          renderUploadTemplate={this.templateUploadAction}
        />
      );
    }

    return null;
  }

  /* MODAL HANDLERS */

  private openModal = () => this.uiStore.setModalOpen(true);

  private closeModal = () => this.uiStore.setModalOpen(false);

  private resetModal = () => this.uiStore.setModalContent(null);

  private toggleModal = (action: Action) => this.uiStore.setModalContent(action);

  /* MODAL CONTENT */

  private templateShowAction = (product: Product): JSX.Element => {
    this.productStore.applyExchangeRate(product);

    return (
      <List bulleted>
        <List.Item>Category: <i>{product.categoryName} (#{product.categoryId})</i></List.Item>
        <List.Item>Name: <i>{product.name}</i></List.Item>
        <List.Item>Price: <i>{product.price} {product.currency}</i></List.Item>
        <List.Item>Display Price: <i>{product.displayPrice} {product.displayCurrency}</i></List.Item>
        <List.Item>Identifier: <i>{product.identifier}</i></List.Item>
      </List>
    );
  };

  private templateUpdateAction = (product: Product, parentSubmitRef: (ref: React.Component) => void): JSX.Element => {
    return (
      <ProductForm
        product={product}
        categoryOptions={this.categoryStore.options}
        parentSubmitRef={parentSubmitRef}
      />
    );
  };

  private templateCreateAction = (parentSubmitRef: (ref: React.Component) => void): JSX.Element => {
    return (
      <ProductForm
        categoryOptions={this.categoryStore.options}
        parentSubmitRef={parentSubmitRef}
      />
    );
  };

  private templateUploadAction = (parentSubmitRef: (ref: React.Component) => void): JSX.Element => {
    return (
      <ProductUploadForm
        categoryOptions={this.categoryStore.options}
        parentSubmitRef={parentSubmitRef}
      />
    );
  }

}

export default ProductsAdminPage;
