SET SERVEROUTPUT ON;

DECLARE
    v_transaction_id   NUMBER := 1000; -- Starting ID for transactions
    v_customer_count   CONSTANT NUMBER := 10;
    v_product_count    CONSTANT NUMBER := 10;
    v_start_date       DATE := TO_DATE('2025-01-01', 'YYYY-MM-DD');
    v_days_in_period   NUMBER := 90; -- ~3 months (Jan 1 - Mar 31)
    v_random_customer  NUMBER;
    v_random_product   NUMBER;
    v_random_pharmacy  NUMBER;
    v_random_date      DATE;
    v_random_quantity  NUMBER;
BEGIN
    FOR i IN 1..100 LOOP
        -- 1. Determine Customer, Product, and Pharmacy IDs randomly
        -- Customer IDs range from 101 to 110
        v_random_customer := TRUNC(DBMS_RANDOM.VALUE(1, v_customer_count + 1)) + 100;
        
        -- Product IDs range from 201 to 210
        v_random_product := TRUNC(DBMS_RANDOM.VALUE(1, v_product_count + 1)) + 200;
        
        -- Pharmacy IDs range from 1 to 5
        v_random_pharmacy := TRUNC(DBMS_RANDOM.VALUE(1, 5 + 1));
        
        -- 2. Determine a random date within the 90-day range
        v_random_date := v_start_date + TRUNC(DBMS_RANDOM.VALUE(0, v_days_in_period));

        -- 3. Determine quantity (1 to 5 units)
        v_random_quantity := TRUNC(DBMS_RANDOM.VALUE(1, 5 + 1));
        
        -- 4. Increment the transaction ID
        v_transaction_id := v_transaction_id + 1;

        -- 5. Execute the INSERT statement
        EXECUTE IMMEDIATE '
            INSERT INTO transactions (transaction_id, customer_id, product_id, pharmacy_id, quantity, sale_date) 
            VALUES (:1, :2, :3, :4, :5, :6)
        ' USING v_transaction_id, v_random_customer, v_random_product, v_random_pharmacy, v_random_quantity, v_random_date;
        
    END LOOP;
    
    -- Commit the 100 transactions
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Successfully inserted 100 transactions.');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting transactions: ' || SQLERRM);
        ROLLBACK;
END;
/














