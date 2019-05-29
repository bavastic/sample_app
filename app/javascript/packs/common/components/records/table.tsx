import * as React from 'react';
import { Header, Table, ButtonProps, Label } from 'semantic-ui-react'

import Record from '../../../models/record.model';

import { ShowAction, UpdateAction, DestroyAction } from './list.view.actions';

interface ActionHandlers {
  showAction: (record: Record) => (event: React.MouseEvent<HTMLButtonElement>, data: ButtonProps) => void
  updateAction: (record: Record) => (event: React.MouseEvent<HTMLButtonElement>, data: ButtonProps) => void
  destroyAction: (record: Record) => (event: React.MouseEvent<HTMLButtonElement>, data: ButtonProps) => void
}

/* TABLE */

interface RecordsTableProps extends ActionHandlers {
  records: Record[]
}

export const RecordsTable = (props: RecordsTableProps): JSX.Element => {
  return (
    <Table celled unstackable>
      <Table.Header>
        <Table.Row>
          <Table.HeaderCell>Record</Table.HeaderCell>
          <Table.HeaderCell>Actions</Table.HeaderCell>
        </Table.Row>
      </Table.Header>

      <Table.Body>
        {props.records.map(item => {
          return (
            <RecordTableCell
              record={item}
              key={item.id as number}
              showAction={props.showAction}
              destroyAction={props.destroyAction}
              updateAction={props.updateAction}
            />
          );
        })}
      </Table.Body>
    </Table>
  );
};

export default RecordsTable;

/* TABLE CELL */

interface RecordTableCellProps extends ActionHandlers {
  record: Record;
}

const rightLabelStyle = {
  float: 'right'
};

const RecordTableCell = (props: RecordTableCellProps): JSX.Element => {
  return (
    <Table.Row>
      <Table.Cell>
        <Header as='h4'>
          <Header.Content>{props.record.displayName}</Header.Content>
          <Label style={rightLabelStyle}>{props.record.identifier}</Label>
        </Header>
      </Table.Cell>

      <Table.Cell collapsing>
        <div className="ui small basic icon buttons">
          <ShowAction handler={props.showAction} subject={props.record}/>
          <UpdateAction handler={props.updateAction} subject={props.record}/>
          <DestroyAction handler={props.destroyAction} subject={props.record}/>
        </div>
      </Table.Cell>
    </Table.Row>
  );
};
