-module(es1).
-export([is_palindrome/1, is_an_anagram/2, factors/1, is_proper/1]).

% is_palindrome: String -> bool. checks if the string given as input is palindrome,
% a string is palindrome when the represented sentence can be read the same way 
% in either directions in spite of spaces, punctual and letter cases, 
% e.g., detartrated, "Do geese see God?", "Rise to vote, sir.", ...

is_palindrome(S) -> STR = [C || C <- string:casefold(S), C >= $a andalso C < $z+1], string:equal(STR, string:reverse(STR)).

%is_an_anagram : string → string list → boolean that given a dictionary of strings,
%checks if the input string is an anagram of one or more of the strings in the dictionary.

prepare_string(S) -> lists:sort(string:casefold(S)).

is_an_anagram(S, List) -> STR=prepare_string(S), lists:any(fun(X) -> prepare_string(X)==STR end, List).

%factors: int → int list that given a number calculates all its prime factors;

factors(N) -> aux(N, N, 2, []).

aux(N, _, M, L) when M*2 >= N -> L; 
aux(N, D, M, L) when D rem M == 0 -> aux(N, round(D/M), M, [M | L]);
aux(N, D, M, L) -> aux(N, D, M+1, L).

%is_proper: int → boolean that given a number calculates if it is a perfect number or not,
%where a perfect number is a positive integer equal to the sum of its proper positive divisors (excluding itself),
%e.g., 6 is a perfect number since 1, 2 and 3 are the proper divisors of 6 and 6 is equal to 1+2+3;

is_proper(N) -> lists:sum([X || X <- lists:seq(1,round(N/2)), N rem X == 0 ]) == N.