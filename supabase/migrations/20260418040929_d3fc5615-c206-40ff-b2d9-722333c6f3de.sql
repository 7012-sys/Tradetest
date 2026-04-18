-- Remove user-side INSERT/DELETE on subscriptions (only service_role/admin should manage these)
DROP POLICY IF EXISTS "Users can insert own subscription" ON public.subscriptions;
DROP POLICY IF EXISTS "Users can delete own subscription" ON public.subscriptions;

-- Allow public read of strategy_likes so community pages can show like counts
CREATE POLICY "Anyone can view likes on public community strategies"
ON public.strategy_likes
FOR SELECT
TO public
USING (
  EXISTS (
    SELECT 1 FROM public.community_strategies cs
    WHERE cs.id = strategy_likes.strategy_id
      AND cs.visibility = 'public'
  )
);