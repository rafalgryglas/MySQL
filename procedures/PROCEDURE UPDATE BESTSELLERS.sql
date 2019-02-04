alter table books add BESTSELLER boolean;


drop procedure if exists UpdateBestsellers;

delimiter $$

create procedure UpdateBestsellers()
begin
	declare result int;
	declare days, b_id, booksLend int;
   
    declare finished int default 0;
    declare all_books cursor for select BOOK_ID from books;
    declare continue handler for not found set finished = 1;
    
    open all_books;
    while (finished = 0) do
		fetch all_books into b_id;
        if(finished = 0) then
			select count(*),datediff(Max(RENT_DATE),Min(RENT_DATE)) as days from rents
            where BOOK_ID = b_id
            into booksLend, days;
            set result = booksLend/days * 30;
            if result>=2 then
			
				update books set bestseller = true 
				where BOOK_ID=b_id;
			else
				update books set bestseller = false 
				where BOOK_ID=b_id;
			end if;
			commit;
		end if;
	end while;
	close all_books;
end $$

delimiter ;