import { InputText } from 'primereact/inputtext';
import { Button } from 'primereact/button';
import { useNavigate } from 'react-router-dom';
import './LoginPage.css';

export default function LoginPage() {

      const navigate = useNavigate();

      const goToApp = () => {
        navigate('/app');
      };

    return (
        <div className="layout">
            <p>Here for Resins?</p>
            <div>
            <InputText placeholder="Username" className="username-input"/>
            </div>
            <div>
            <InputText placeholder="Password" type="password" className="password-input"/>
            </div>
            <div>
            <Button onClick={goToApp} label="Submit"/>
            </div>
        </div>
    )
}