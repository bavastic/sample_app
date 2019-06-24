import * as React from 'react';
import { Modal, Form } from 'semantic-ui-react';
import { Button } from 'semantic-ui-react';
import CategoryStore from '../../../../stores/category.store';

interface Properties {
  bodyRenderer?: (parentSubmitRef: (ref: React.Component) => void) => JSX.Element;
  parentSubmitRef: (ref: React.Component) => void;
}

class UploadView extends React.Component<Properties, {selectedFile: null, loaded: 0}> {
  
   
    public render() {
        const { bodyRenderer, parentSubmitRef: ref } = this.props;
        console.log(this.props)
        return (
          <>
            <Modal.Header>Batch Upload</Modal.Header>
            <Modal.Content>
              <Modal.Description>
              {bodyRenderer && bodyRenderer(ref)}
              </Modal.Description>
            </Modal.Content>
          </>
        );
    }

    
}

export default UploadView;
