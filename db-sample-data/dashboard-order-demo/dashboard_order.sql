-- Create a table to store dashboard order information
CREATE TABLE IF NOT EXISTS public.dashboard_order (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    city VARCHAR(30),                      -- NULL for personal dashboards
    dashboard_indexes JSONB NOT NULL,      -- Stores array of dashboard indexes in order
    _ctime TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    _mtime TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_dashboard_order_user_id ON dashboard_order(user_id);
CREATE INDEX IF NOT EXISTS idx_dashboard_order_city ON dashboard_order(city);

-- Create constraint
ALTER TABLE ONLY public.dashboard_order
	ADD CONSTRAINT unique_user_city UNIQUE (user_id, city);

-- Create trigger to update the _mtime timestamp
CREATE OR REPLACE FUNCTION public.update_dashboard_order_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW._mtime = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_dashboard_order_timestamp
BEFORE UPDATE ON dashboard_order
FOR EACH ROW
EXECUTE FUNCTION public.update_dashboard_order_timestamp();
