// Divider.js
export function Divider() {
    return (
        <div style={{position: 'relative', marginTop: '60px'}}>
            <div style={{position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', borderTop: '1px solid #e0e0e0'}} aria-hidden="true"></div>
            <div style={{position: 'relative', display: 'flex', justifyContent: 'start'}}></div>
        </div>
    );
}
