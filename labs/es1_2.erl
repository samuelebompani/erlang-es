-module(es1_2).
-export([squared_int/1, intersect/2, symmetric_difference/2]).

%squared_int removes all non-integers from a polymorphic list and returns the resulting list of integers squared,
%e.g., squared_int([1, hello, 100, boo, “boo”, 9]) should return [1, 10000, 81].

squared_int(List) -> [X*X || X <- List, is_integer(X)].

%intersect that given two lists, returns a new list that is the intersection of the two lists
%(e.g., intersect([1,2,3,4,5], [4,5,6,7,8]) should return [4,5]).

intersect(List1, List2) -> [X || X <- List1, Y <- List2, X==Y].

%symmetric_difference that given two lists, returns a new list that is the symmetric difference of the two lists. 
%For example symmetric_difference([1,2,3,4,5], [4,5,6,7,8]) should return [1,2,3,6,7,8].

symmetric_difference(List1, List2) -> [X || X <- List1, not lists:member(X, List2)] ++ [Y || Y <- List2, not lists:member(Y, List1)].

%alternative version:
%symmetric_difference(List1, List2) -> [Z || Z <- lists:merge(List1, List2), not lists:any(fun(X) -> X==Z end, List2) orelse not lists:any(fun(X) -> X==Z end, List1)].