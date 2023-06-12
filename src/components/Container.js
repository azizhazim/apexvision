// Container.js
import { forwardRef } from "react";

const OuterContainer = forwardRef(({ className, children, ...props }, ref) => {
    return (
        <div
            ref={ref}
            style={{
                padding: '10px',
                backgroundColor: '#F5F5F5',
                borderRadius: '5px'
            }}
            {...props}
        >
            <h1 style={{textAlign: 'center', fontSize: '24px', fontWeight: '700', color: '#212121'}}>Vision AI Assistant</h1>
            <div style={{margin: '10px', backgroundColor: '#fff', borderRadius: '5px'}}>{children}</div>
        </div>
    );
});

const InnerContainer = forwardRef(({ className, children, ...props }, ref) => {
    return (
        <div
            ref={ref}
            style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',  // added to align items in the center
                margin: '10px',
                gap: '10px',
                minWidth: '280px',  // reduced a bit
                minHeight: '280px',  // reduced a bit
            }}
            {...props}
        >
            {children}
        </div>
    );
});

export const Container = forwardRef(({ children, ...props }, ref) => {
    return (
        <OuterContainer ref={ref} {...props}>
            <InnerContainer>{children}</InnerContainer>
        </OuterContainer>
    );
});

Container.Outer = OuterContainer;
Container.Inner = InnerContainer;
