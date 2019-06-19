import * as React from 'react';
import { Modal, Form } from 'semantic-ui-react';
import { Button } from 'semantic-ui-react';
import CategoryStore from '../../../../stores/category.store';

class CategoryUploadView extends React.Component<{}, {selectedFile: null, loaded: 0}> {
    constructor(props) {
        super(props);
          this.state = {
            selectedFile: null,
            loaded: 0
          }
      }
    public render() {
        //const { bodyRenderer, parentSubmitRef: ref } = this.props;
    
        return (
          <>
            <Modal.Header>Batch-Upload Categories</Modal.Header>
            <Modal.Content>
              <Modal.Description>
                <input type="file" name="file" onChange={this.onChangeHandler}/>
                <Button content='Upload File' onClick={this.onClickHandler} />
              </Modal.Description>
            </Modal.Content>
          </>
        );
    }

    onChangeHandler=event=>{
        this.setState({
            selectedFile: event.target.files[0],
            loaded: 0,
        })
    }

    onClickHandler = () => {
        const data = new FormData();
        data.append('categoryFile', this.state.selectedFile);
        var cs = new CategoryStore();
        console.log(this.state.selectedFile);
        cs.uploadCategoryFile(data);
    }
}

export default CategoryUploadView;
