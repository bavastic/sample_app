import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { List } from 'semantic-ui-react';

import UiStore, { Action } from '../../stores/ui.store';
import CategoryStore from '../../stores/category.store';
import Category from '../../models/category.model';

import Loading from '../../common/components/loading';
import RecordsListView from '../../common/components/records/list.view';
import { CategoryForm } from './category.forms';
import { CategoryUploadForm } from './category.upload';

interface Properties {
}

interface InjectedProps extends Properties {
  uiStore: UiStore;
  categoryStore: CategoryStore;
}

@inject('uiStore', 'categoryStore')
@observer
class CategoriesAdminPage extends React.Component<Properties> {

  get injected() {
    return this.props as InjectedProps;
  }

  get uiStore() {
    return this.injected.uiStore;
  }

  get categoryStore() {
    return this.injected.categoryStore;
  }

  componentDidMount() {
    this.categoryStore.getItems();

    // TODO: implement lazy evaluation, needed for form only
    this.categoryStore.getOptions();
  }

  public render() {
    if (this.categoryStore.isLoading) {
      return <Loading/>;
    }

    if (this.uiStore.selectedAction === Action.Index) {
      return (
        <RecordsListView
          records={this.categoryStore.items}
          selectedRecord={this.categoryStore.selectedItem}
          onSelectRecord={this.categoryStore.setSelectedItem}
          onDestroyRecord={this.categoryStore.destroyItem}
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

  private templateShowAction = (category: Category): JSX.Element => {
    if (category.parentId === null) {
      return (
        <List bulleted>
          <List.Item>Name: <i>{category.name}</i></List.Item>
          <List.Item>Identifier: <i>{category.identifier}</i></List.Item>
        </List>
      );
    }

    return (
      <List bulleted>
        <List.Item>Parent: <i>{category.parentName} (#{category.parentId})</i></List.Item>
        <List.Item>Name: <i>{category.name}  (#{category.id})</i></List.Item>
        <List.Item>#Products: <i>{category.productsCount || 0}</i></List.Item>
        <List.Item>Identifier: <i>{category.identifier}</i></List.Item>
      </List>
    );
  };

  private templateUpdateAction = (category: Category, parentSubmitRef: (ref: React.Component) => void): JSX.Element => {
    return (
      <CategoryForm
        category={category}
        parentCategoryOptions={this.categoryStore.options}
        parentSubmitRef={parentSubmitRef}
      />
    );
  };

  private templateCreateAction = (parentSubmitRef: (ref: React.Component) => void): JSX.Element => {
    return (
      <CategoryForm
        parentCategoryOptions={this.categoryStore.options}
        parentSubmitRef={parentSubmitRef}
      />
    );
  };

  private templateUploadAction = (parentSubmitRef: (ref: React.Component) => void): JSX.Element => {
    return (
      <CategoryUploadForm
        parentCategoryOptions={this.categoryStore.options}
        parentSubmitRef={parentSubmitRef}
      />
    );
  };

}

export default CategoriesAdminPage;
