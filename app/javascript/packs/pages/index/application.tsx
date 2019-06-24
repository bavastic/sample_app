import * as React from 'react';
import { inject, observer } from 'mobx-react';
import { Container } from 'semantic-ui-react';

import UiStore, { Action, Module } from '../../stores/ui.store';

import ApplicationMenu from './application-menu';
import ApplicationStatus from './application-status';

import CategoriesAdminPage from '../admin/categories.page';
import ProductsAdminPage from '../admin/products.page';

interface Properties {
}

interface InjectedProps extends Properties {
  uiStore: UiStore
}

@inject('uiStore')
@observer
class Application extends React.Component<Properties> {

  get injected() {
    return this.props as InjectedProps;
  }

  get uiStore() {
    return this.injected.uiStore;
  }

  public componentDidMount() {
    this.uiStore.selectModule(Module.Category);
    this.uiStore.selectAction(Action.Index);
  }

  public render() {
    let controller;

    switch (this.uiStore.selectedModule) {
      case Module.Category: {
        controller = <CategoriesAdminPage/>;
        break;
      }

      case Module.Product: {
        controller = <ProductsAdminPage/>;
        break;
      }

      default: {
        break;
      }
    }

    return (
      <>
        <ApplicationMenu/>
        <ApplicationStatus defaultTimeout={3000} />
        <Container text style={{ margin: '2em 0' }}>
          {controller}
        </Container>

        
      </>
    );
  }

}

export default Application;
