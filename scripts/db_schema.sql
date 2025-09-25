BEGIN
    BEGIN
    EXECUTE IMMEDIATE '
        CREATE TABLE pharmacies (
            pharmacy_id NUMBER(10) PRIMARY KEY,
            name VARCHAR2(100) NOT NULL,
            county VARCHAR2(50) NOT NULL
        )
    ';
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -955 THEN
                NULL; 
            ELSE
                RAISE;
            END IF;
    END;

    BEGIN
        EXECUTE IMMEDIATE '
            CREATE TABLE customers (
                customer_id NUMBER(10) PRIMARY KEY,
                name VARCHAR2(100) NOT NULL,
                pharmacy_id NUMBER(10) REFERENCES pharmacies(pharmacy_id)
            )
        ';
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -955 THEN
                NULL; 
            ELSE
                RAISE;
            END IF;
    END;

    BEGIN
        EXECUTE IMMEDIATE '
            CREATE TABLE products (
                product_id NUMBER(10) PRIMARY KEY,
                name VARCHAR2(100) NOT NULL,
                price NUMBER(10, 2) NOT NULL
            )
        ';
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -955 THEN
                NULL; 
            ELSE
                RAISE;
            END IF;
    END;

    BEGIN
        EXECUTE IMMEDIATE '
            CREATE TABLE transactions (
                transaction_id NUMBER(10) PRIMARY KEY,
                customer_id NUMBER(10) REFERENCES customers(customer_id),
                product_id NUMBER(10) REFERENCES products(product_id),
                pharmacy_id NUMBER(10) REFERENCES pharmacies(pharmacy_id),
                quantity NUMBER(5) NOT NULL,
                sale_date DATE NOT NULL
            )
        ';
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -955 THEN
                NULL; 
            ELSE
                RAISE;
            END IF;
    END;
END;
/