import './ResinPage.css';
import { Dropdown } from 'primereact/dropdown';
import { useState } from "react";


export default function ResinPage() {


    const [selectedResin, setSelectedResin] = useState(null);

    const resins = [
        { name: 'John', code: 'Doe' },
        { name: 'Rome', code: 'RM' },
    ];

    return (
        <div className="layout">
            <Dropdown value={selectedResin} onChange={(e) => setSelectedResin(e.value)} options={resins} optionLabel="name"
                placeholder="Select Resin 1" editable={true}/>
            <h1>We did it!</h1>
        </div>
    )
}