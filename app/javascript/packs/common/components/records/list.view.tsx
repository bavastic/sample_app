import { observer } from 'mobx-react';
import * as React from 'react';
import { Button, ButtonProps, List, Segment } from 'semantic-ui-react'

import { logger } from '../../../common/logger';

import { Action, Notification, NotificationLevel } from '../../../stores/ui.store';

import Record from '../../../models/record.model';

import RecordsTable from './table';
import { RecordListViewModal as Modal } from './list.view.modal';

import { default as CreateView } from './modals/create.view';
import { default as ShowView } from './modals/show.view';
import { default as UpdateView } from './modals/update.view';
import { default as DestroyView } from './modals/destroy.view';
import { default as UploadView } from './modals/upload.view';

interface ModalProps {
  modalOpen: boolean;
  modalContent: Action;

  openModal: () => void;
  closeModal: () => void;
  resetModal: () => void;
  toggleModal: (action: Action) => void;

  renderShowTemplate?: (record: Record) => JSX.Element;
  renderDestroyTemplate?: (record: Record) => JSX.Element;
  renderUpdateTemplate?: (record: Record, parentSubmitRef: (ref: React.Component) => void) => JSX.Element;
  renderCreateTemplate?: (parentSubmitRef: (ref: React.Component) => void) => JSX.Element;
  renderUploadTemplate?: (parentSubmitRef: (ref: React.Component) => void) => JSX.Element;
}

interface Properties extends ModalProps {
  records: Record[]
  selectedRecord: Record;

  onSelectRecord: (record: Record) => void;
  onDestroyRecord: (record?: Record) => Promise<void>;
  onSystemNotification: (...notifications: Notification[]) => void;
}

@observer
class RecordsListView extends React.Component<Properties> {

  state = {
    formRef: undefined,
  };

  public render() {
    const {
      records,
      selectedRecord,
      modalOpen,
      modalContent,
      closeModal,
      renderShowTemplate,
      renderDestroyTemplate,
      renderUpdateTemplate,
      renderCreateTemplate,
      renderUploadTemplate
    } = this.props;

    let modal;

    switch (modalContent) {
      case Action.Show:
        modal = (
          <Modal open={modalOpen} closeModal={closeModal}>
            <ShowView record={selectedRecord} bodyRenderer={renderShowTemplate}/>
          </Modal>
        );
        break;

      case Action.Upload:
        modal = (
          <Modal open={modalOpen} closeModal={closeModal}>
            <UploadView bodyRenderer={renderUploadTemplate} parentSubmitRef={this.setFormRef}></UploadView>
        </Modal>
        );
        break;
      case Action.Destroy:
        modal = (
          <Modal open={modalOpen} closeModal={closeModal}
                 confirmDestroyModal={this.handleDestroyActionConfirmed}
                 record={selectedRecord}>
            <DestroyView record={selectedRecord} bodyRenderer={renderDestroyTemplate}/>
          </Modal>
        );
        break;

      case Action.Update:
        modal = (
          <Modal open={modalOpen} closeModal={closeModal}
                 confirmUpdateModal={this.handleUpdateActionConfirmed}
                 record={selectedRecord}>
            <UpdateView record={selectedRecord} bodyRenderer={renderUpdateTemplate} parentSubmitRef={this.setFormRef}/>
          </Modal>
        );
        break;

      case Action.Create:
        modal = (
          <Modal open={modalOpen} closeModal={closeModal}
                 confirmCreateModal={this.handleCreateActionConfirmed}>
            <CreateView bodyRenderer={renderCreateTemplate} parentSubmitRef={this.setFormRef}/>
          </Modal>
        );
        break;

      default: {
        modal = null;
        break;
      }
    }

    const table = (records.length > 0) ? (
      <RecordsTable
        records={records}
        showAction={this.handleShowAction}
        destroyAction={this.handleDestroyAction}
        updateAction={this.handleUpdateAction}
      />
    ) : null;

    return (
      <>
        {modal}

        <Segment raised textAlign='right'>
          <Button color='blue' onClick={this.handleCreateAction} content='New' icon='add' labelPosition='right'/>
          <Button color='blue' onClick={this.handleUploadAction} content='Upload Excel File' icon='upload' labelPosition='right' />
        </Segment>

        {table}
        
        
        
        </>
    );
  }

  /*
   * Show action: renders Record details view within modal dialog.
   */
  private handleShowAction = (record: Record) => (event: React.MouseEvent<HTMLButtonElement>, data: ButtonProps) => {
    this.props.toggleModal(Action.Show);
    this.props.onSelectRecord(record);
    this.props.openModal();
  };

  /*
   * Destroy action: open modal dialog, provides a cancel and confirm button.
   */
  private handleDestroyAction = (record: Record) => (event: React.MouseEvent<HTMLButtonElement>, data: ButtonProps) => {
    this.props.toggleModal(Action.Destroy);
    this.props.onSelectRecord(record);
    this.props.openModal();
  };

  /*
   * Confirm destroy action: triggers record destroy from Record recordstore.
   */
  private handleDestroyActionConfirmed = (record: Record) => (event: React.MouseEvent<HTMLButtonElement>, data: ButtonProps) => {
    logger.of('handleDestroyActionConfirmed').trace();

    this.props.closeModal();
    this.props.onSelectRecord(null);
    this.props.resetModal();

    this.props.onDestroyRecord(record)
      .then(() => {
        this.props.onSystemNotification({
          level: NotificationLevel.Notice,
          message: `Successfully deleted record: ${record.displayName}`
        });
      })
      .catch((error) => {
        this.props.onSystemNotification(error.data.notification);
      });
  };

  /*
   * Update action: open dialog.
   */
  private handleUpdateAction = (record: Record) => (event: React.MouseEvent<HTMLButtonElement>, data: ButtonProps) => {
    logger.of('handleUpdateAction').trace();

    this.props.toggleModal(Action.Update);
    this.props.onSelectRecord(record);
    this.props.openModal();
  };

  /*
   * Update action: confirm and apply action.
   */
  private handleUpdateActionConfirmed = (record: Record) => (event: React.MouseEvent<HTMLButtonElement>, data: ButtonProps) => {
    logger.of('handleUpdateActionConfirmed').trace();

    this.props.closeModal();
    this.props.onSelectRecord(null);
    this.props.resetModal();
    this.state.formRef.doSubmit();
  };

  /*
   * Create action: open dialog.
   */
  private handleCreateAction = (event: React.MouseEvent<HTMLButtonElement>, data: ButtonProps) => {
    logger.of('handleCreateAction').trace();

    this.props.toggleModal(Action.Create);
    this.props.openModal();
  };

  /*
   * Create action: confirm and apply action.
   */
  private handleCreateActionConfirmed = (event: React.MouseEvent<HTMLButtonElement>, data: ButtonProps) => {
    logger.of('handleCreateActionConfirmed').trace();

    this.props.closeModal();
    this.props.resetModal();
    this.state.formRef.doSubmit();
  };

  /*
   * Upload action: Open Upload Modal.
   */
  private handleUploadAction = (event: React.MouseEvent<HTMLButtonElement>, data: ButtonProps) => {
    logger.of('handleUploadAction').trace();

    this.props.toggleModal(Action.Upload);
    this.props.openModal();
  };

  /*
   * Callback method to set a form reference, enables submits from components outside the form.
   */
  private setFormRef = (ref: React.Component): void => {
    logger.of('setFormRef').data('ref', ref);

    this.setState({ formRef: ref });
  }

}

export default RecordsListView;
