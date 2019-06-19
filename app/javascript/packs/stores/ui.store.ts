import { action, computed, observable } from 'mobx';

import { logger } from '../common/logger';

/**
 * Holds list of available React frontend modules.
 */
export enum Module {
  Category = 'category',
  Product = 'product',
}

/**
 * Holds actions for React frontend, similiar to Rails controller actions.
 */
export enum Action {
  Index = 'index',
  Create = 'create',
  Update = 'update',
  Show = 'show',
  Destroy = 'destroy',
  Upload = 'upload'
}

export enum NotificationLevel {
  Notice = 'notice',
  Alert = 'alert',
  Error = 'error',
}

export interface Notification {
  level: NotificationLevel;
  message: string;
  instant?: boolean;
  timeout?: number;
}

/**
 * User interface productStore to manage UI state.
 */
export default class UiStore {

  public constructor() {
    this.selectedModule = null;
    this.selectedAction = Action.Index;
    this.notifications = observable.array([]);
    this.activePage = 1;
    this.itemsPerPage = 30;
  }

  /* ROUTING */

  /**
   * Acts as a basic router, switches between Category and Product module.
   */
  @observable public selectedModule: Module | null;

  @action
  public selectModule = (module: Module): void => {
    logger.of('UiStore.selectModule').data('module', module);

    this.selectedModule = module;
  };

  /**
   * Determines current user CRUD action within selected module.
   */
  @observable public selectedAction: Action | null;

  @action
  public selectAction = (action: Action): void => {
    logger.of('UiStore.selectAction').data('action', action);

    this.selectedAction = action;
  };

  /* GENERAL UI */

  /**
   * Semantic UI: support for sticky menu bar.
   */
  @observable public menuFixed: boolean = false;

  @action
  public setMenuFixed(bool: boolean): void {
    logger.of('UiStore.setMenuFixed').data('bool', bool);

    this.menuFixed = bool;
  }

  /* NOTIFICATIONS */

  @observable public notifications: Notification[];

  @action
  public addNotifications = (...notifications: Notification[]): void => {
    logger.of('UiStore.addNotification').data('notifications', notifications);

    if (notifications && notifications.length > 0) {
      this.notifications.push(...notifications);
    } else {
      this.notifications.push({ level: NotificationLevel.Alert, message: 'Unknown error happened.' })
    }
  };

  @computed
  public get hasNotifications(): boolean {
    logger.of('UiStore.hasNotifications').trace();

    return this.notifications.length > 0;
  }

  @computed
  public get nextNotification(): Notification | null {
    logger.of('UiStore.nextNotification').trace();

    return this.hasNotifications ? this.notifications[0] : null;
  };

  @action
  public dequeueNotification = (): void => {
    logger.of('UiStore.dequeueNotification').trace();

    this.hasNotifications ? this.notifications.shift() : false;
  };

  @action
  public clearNotifications = (): void => {
    logger.of('UiStore.clearNotifications').trace();

    this.notifications = [];
  };

  /* MODAL STATE */

  /**
   * Semantic UI: state for modal dialog, open or closed.
   */
  @observable public modalOpen: boolean = false;

  @action
  public setModalOpen(bool: boolean): void {
    logger.of('UiStore.setModalOpen').data('bool', bool);

    this.modalOpen = bool;
  }

  /**
   * Semantic UI: modal content body, according to CRUD action.
   */
  @observable public modalContent: Action | null = null;

  @action
  public setModalContent(action: Action | null): void {
    logger.of('UiStore.setModalContent').data('action', action);

    this.modalContent = action;
  }

  /* PAGINATION */

  @observable public query: string = "";

  @action
  public setQuery = (query: string): void => {
    logger.of('UiStore.setQuery').data('query', query);

    this.query = query;
  };

  /**
   * Semantic UI: number of records shown per table page.
   */
  @observable public itemsPerPage: number;

  /**
   * Semantic UI: active page for table paginator.
   */
  @observable public activePage: number;

  @action
  public setActivePage(page: number): void {
    logger.of('UiStore.setActivePage').data('page', page);

    this.activePage = page;
  }

  /**
   * Semantic UI: number of total pages for table paginator.
   */
  @observable public totalPages: number;

  @action
  public updatePagination(numElements: number): void {
    logger.of('UiStore.updatePagination').trace();

    this.totalPages = Math.ceil(numElements / this.itemsPerPage);
    logger.of('UiStore.updatePagination').debug(`${this.totalPages} pages total, ${this.itemsPerPage} records per page, ${numElements} items total`);
  }

}

export let store = new UiStore();
