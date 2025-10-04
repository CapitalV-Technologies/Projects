import './Navbar.css';
import { type MouseEventHandler } from 'react';
import 'primeicons/primeicons.css';
import { Button } from 'primereact/button';

type NavbarProps = {
    toggleSidebar: MouseEventHandler<HTMLButtonElement>;
}

export default function Navbar({toggleSidebar}: NavbarProps) {
    
    return (
        <div className="navbar">
            <Button className='navbar-button' icon='pi pi-bars' onClick={toggleSidebar}/>
            <h1 className='navbar-header'>Project Name</h1>
            <p className='navbar-company'>CapitalVTech</p>
        </div>
    );
}
