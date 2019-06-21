import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { Form, Select } from 'semantic-ui-react'
import { Button } from 'semantic-ui-react';
import Dropzone from 'react-dropzone';

import { Option } from '../../stores/simple.store';
import UiStore, { NotificationLevel } from '../../stores/ui.store';

import CategoryStore from '../../stores/category.store';
import Category from '../../models/category.model';
import { logger } from '../../common/logger';

interface Properties {
  category?: Category;
  parentCategoryOptions: Option[];

  parentSubmitRef: (ref: React.Component) => void;
}

interface InjectedProps extends Properties {
  uiStore: UiStore;
  categoryStore: CategoryStore;
}

@inject('uiStore', 'categoryStore')
@observer
export class CategoryUploadForm extends React.Component<Properties> {

  state = {
    parentId: undefined,
    name: '',
    selectedFile: null,
    loaded: 0

  };

  get injected() {
    return this.props as InjectedProps;
  }

  get uiStore() {
    return this.injected.uiStore;
  }

  get categoryStore() {
    return this.injected.categoryStore;
  }

  public componentDidMount() {
    const { category, parentSubmitRef } = this.props;

    if (category) {
      this.setState({
        parentId: category.parentId,
        name: category.name,
      });
    }

    parentSubmitRef(this);
  }

  public render() {
    const { category, parentCategoryOptions } = this.props;
    const { parentId, name } = this.state;

    const options = category ? parentCategoryOptions.filter(i => i.value !== category.id) : parentCategoryOptions;

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
    data.append('category_file', file);
    this.categoryStore.uploadCategoryFile(data).then(res => {
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
    
  };

}
