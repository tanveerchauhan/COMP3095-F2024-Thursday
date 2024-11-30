-- Terminate all active connections to the 'inventory-service' database
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_database WHERE datname = 'inventory-service') THEN
        PERFORM pg_terminate_backend(pg_stat_activity.pid)
        FROM pg_stat_activity
        WHERE pg_stat_activity.datname = 'inventory-service'
          AND pid <> pg_backend_pid(); -- Exclude the current process
END IF;
END $$;

-- Drop the database if it exists
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_database WHERE datname = 'inventory-service') THEN
        EXECUTE 'DROP DATABASE "inventory-service"';
END IF;
END $$;

-- Create the new 'inventory-service' database
CREATE DATABASE "inventory-service";

-- Switch to 'inventory-service' and create a table
-- This part won't work in IntelliJ, but works in Docker entrypoint
CREATE TABLE IF NOT EXISTS inventory (
                                         id SERIAL PRIMARY KEY,
                                         item_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    price NUMERIC(10, 2) NOT NULL
    );
