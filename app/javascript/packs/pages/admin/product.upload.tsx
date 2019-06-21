import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { Form, Select } from 'semantic-ui-react'
import { Button } from 'semantic-ui-react';
import Dropzone from 'react-dropzone';


import { Option } from '../../stores/simple.store';
import UiStore, { NotificationLevel } from '../../stores/ui.store';

import ProductStore from '../../stores/product.store';
import Product from '../../models/product.model';

interface Properties {
  product?: Product;
  categoryOptions: Option[];

  parentSubmitRef: (ref: React.Component) => void;
}

interface InjectedProps extends Properties {
  uiStore: UiStore;
  productStore: ProductStore;
}

@inject('uiStore', 'productStore')
@observer
export class ProductUploadForm extends React.Component<Properties> {

  state = {
    categoryId: undefined,
    name: '',
    price: undefined,
    currency: 'EUR',
    displayCurrency: 'EUR',
    selectedFile: null,
    loaded: 0
  };

  get injected() {
    return this.props as InjectedProps;
  }

  get uiStore() {
    return this.injected.uiStore;
  }

  get productStore() {
    return this.injected.productStore;
  }

  public componentDidMount() {
    const { product, parentSubmitRef } = this.props;

    if (product) {
      this.setState({
        categoryId: product.categoryId,
        name: product.name,
        price: product.price,
        currency: product.currency,
        displayCurrency: product.displayCurrency,
      });
    }

    parentSubmitRef(this);
  }

  public render() {
    const { categoryOptions: options } = this.props;
    const { categoryId, name, price, currency, displayCurrency } = this.state;

    return (
      <>
        <Form>
          <Dropzone onDrop={acceptedFiles => this.upload(acceptedFiles[0])}>
          {({getRootProps, getInputProps}) => (
            <section>
              <div {...getRootProps()}>
              <p>Click here to select a file or just drag files onto this box.</p>
              <div className='file_box'></div>
              <input {...getInputProps()}/></div>
            </section>
          )}
          </Dropzone>
        </Form>
      </>
    );
  }

  upload = (file) => {
    const data = new FormData();
    data.append('product_file', file);
    this.productStore.uploadProductFile(data).then(res => {
      if (res.message) {
        this.uiStore.addNotifications({
          level: NotificationLevel.Error,
          message: res.message,
        });
      }
      else {
        this.uiStore.addNotifications({
          level: NotificationLevel.Notice,
          message: 'Import Successful.',
        });
      }
      this.uiStore.setModalOpen(false);
    });
  }


  onChangeHandler=event=>{
    this.setState({
        selectedFile: event.target.files[0],
        loaded: 0,
    })
  }

onClickHandler = () => {
  const data = new FormData();
  data.append('product_file', this.state.selectedFile);
  var cs = this.productStore;
  console.log(this.state.selectedFile);
  cs.uploadProductFile(data);
}


  /*
   * Init form submit from a parent component.
   */
  public doSubmit = (): void => {
    this.handleSubmit();
  };

  /*
   * Update component state after change of input field values.
   */
  private handleChange = (event, { name, value }): void => {
    this.setState({ [name]: value });
  };

  /*
   * Collect form data and invoke data transmission to backend.
   */
  protected handleSubmit = (): void => {
    if (this.props.product) {
      let record = this.props.product;

      record.categoryId = this.state.categoryId;
      record.name = this.state.name;
      record.price = this.state.price;
      record.currency = this.state.currency;
      record.displayCurrency = this.state.displayCurrency;

      this.productStore.updateItem(['categoryId', 'name', 'price', 'currency', 'displayCurrency'], record)
        .then(() => {
          this.uiStore.addNotifications({
            level: NotificationLevel.Notice,
            message: `Successfully updated product: ${record.name}`,
          });
        })
        .catch((error) => {
          this.uiStore.addNotifications(error.data.notification);
        });
    } else {
      const attrs = {
        categoryId: this.state.categoryId,
        name: this.state.name,
        price: this.state.price,
        currency: this.state.currency,
        displayCurrency: this.state.displayCurrency,
      };

      this.productStore.createItem(attrs)
        .then(() => {
          this.uiStore.addNotifications({
            level: NotificationLevel.Notice,
            message: `Successfully created product: ${attrs.name}`,
          });
        })
        .catch((error) => {
          this.uiStore.addNotifications(error.data.notification);
        });
    }
  };

}
