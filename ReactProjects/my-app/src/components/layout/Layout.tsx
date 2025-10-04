import './Layout.css';
import { useState } from 'react';
import Navbar from '../navbar/Navbar.tsx';
import Sidebar from '../sidebar/Sidebar.tsx';
import Footer from '../footer/Footer.tsx';
import { Outlet } from 'react-router-dom';


export default function Layout() {

    const [visible, setVisible] = useState(true);

    const toggle = () => {
        setVisible(!visible);
    }
    return (
        <div>
        <div className="navbar-component">
        <Navbar toggleSidebar={toggle}/>
        </div>
        <div className="body"> 
            <div className="sidebar-component">
        <Sidebar isVisible={visible}/>
        </div>
        <div className="page-component"> 
            <Outlet />
        </div>
        </div>
        <div className="footer-component">
	    <Footer/>
        </div>
        </div>
    );
}
