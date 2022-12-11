with decoded_instructions as (
	select 
		id,
		left(instruction, 4) as op,
		case
			when split_part(instruction, ' ', 2) = '' THEN 0
			else split_part(instruction, ' ', 2)::integer
		end as value
		
	from day_10
)
--select * from decoded_instructions;
, cycle_costs as (
	SELECT * from (values 
		(1, 'noop'), 
		(1, 'addx'), -- addx costs two cycles, so
		(2, 'addx')  -- each has it's own identity
	) as c (n, op)
)
--select * from cycle_costs;
, cycles as (
	select 
		row_number() over (order by di.id, cc.n) as tick,
		n as cycle_num,
		di.op,
		di.value
	from decoded_instructions di
	join cycle_costs cc on di.op = cc.op
)
--select * from cycles;
, execute as (	
	select *,
		(sum(case when op = 'addx' and cycle_num = 2 then value else 0 end) over (order by tick)) + 1 as x 
	from cycles
)
--select * from execute;
, register_values as (
	select tick, lag(x) over (order by tick) as x_reg from execute
)
--select * from register_values;
, signal_strengths as (
	select tick,
	tick * x_reg as signal_strength
	from register_values
)
--select * from signal_strengths;
, display_pos as (
	select case when x_reg is null then 1 else x_reg end as x,
	(tick - 1) / 40 as row,
	(tick - 1) % 40 as col,
	tick
	from register_values
)
--select * from display_pos;
, display_buffers as (
	select *,
		array_agg(case when abs(col - x) < 2 then '#' else '.' end) over (partition by row order by row, col) as buffer
		
	from display_pos
)
--select * from display_buffers;

-- puzzle 1
--select sum(signal_strength) from signal_strengths where (tick - 20) % 40 = 0
-- 14040

-- puzzle 2
--select array_to_string(buffer, '') from display_buffers where col = 39;
