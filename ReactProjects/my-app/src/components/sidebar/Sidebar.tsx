import './Sidebar.css';
import { PanelMenu } from 'primereact/panelmenu';

type SidebarProps = {
    isVisible: boolean;
}

export default function SideBar({isVisible}: SidebarProps) {

    const menu_items = [
        {
            label: "Home",
            id: "1",
            icon: "pi pi-home",
            url: '/app',
        },
        {
            label: "Resins",
            id: "2",
            icon: "pi pi-wrench",
            url: '/yourmom',
        },
        {
            label: "Contact",
            id: "3",
            icon: "pi pi-address-book",
            url: 'app/contact',
        }
    ]
    return (
        <div className={isVisible ? "sidebar sidebar-open" : "sidebar sidebar-close"}>
            <h1 className="sidebar-header">Menu</h1>
            <div>
            <PanelMenu model={menu_items}/>
            </div>
        </div>
    );
}