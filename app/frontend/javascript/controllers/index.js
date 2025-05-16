import { application } from "./application"
import FlashController from "./flash_controller"
import SidebarController from "./sidebar_controller"
import ContactsController from "./contacts_controller"
import DragController from "./drag_controller"
import ProjectNameController from "./project_name_controller"
import SectionsController from "./sections_controller"

application.register("sections", SectionsController)
application.register("project-name", ProjectNameController)
application.register("drag", DragController)
application.register("contacts", ContactsController)
application.register("flash", FlashController)
application.register("sidebar", SidebarController)
